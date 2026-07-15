#!/usr/bin/env python3

import json
import os
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path


OUT = Path(
    os.environ.get(
        "RUNCAT_OUT_FILE", Path.home() / ".codex" / "runcat-usage.json"
    )
)


def scan_transcript(path):
    model = None
    token_count = None
    with path.open(encoding="utf-8") as transcript:
        for line in transcript:
            try:
                record = json.loads(line)
            except (json.JSONDecodeError, TypeError):
                continue
            if not isinstance(record, dict):
                continue
            payload = record.get("payload") or {}
            if not isinstance(payload, dict):
                continue
            if record.get("type") == "turn_context" and payload.get("model"):
                model = payload["model"]
            if (
                record.get("type") == "event_msg"
                and payload.get("type") == "token_count"
            ):
                token_count = payload
    return model, token_count


def window_label(minutes):
    if (
        not isinstance(minutes, (int, float))
        or isinstance(minutes, bool)
        or minutes <= 0
    ):
        return None
    if minutes % 1440 == 0:
        return f"{minutes / 1440:g}d"
    if minutes % 60 == 0:
        return f"{minutes / 60:g}h"
    return f"{minutes:g}m"


def number(value):
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        return None
    return float(value)


def percent_metric(title, value):
    numeric = number(value)
    if numeric is None:
        return None
    clamped = min(max(numeric, 0.0), 100.0)
    displayed = round(clamped, 1)
    return {
        "title": title,
        "formattedValue": f"{displayed:g}%",
        "normalizedValue": round(clamped / 100, 4),
    }


def build_snapshot(model, token_count, now):
    if not isinstance(token_count, dict):
        return None
    info = token_count.get("info") or {}
    last_usage = info.get("last_token_usage") or {}
    total = number(last_usage.get("total_tokens"))
    window = number(info.get("model_context_window"))
    if total is None or window is None or window <= 0:
        return None

    context_percent = total / window * 100
    context = percent_metric("Context", context_percent)
    metrics = [
        {"title": "Model", "formattedValue": model or "Codex"},
        context,
    ]
    limits = token_count.get("rate_limits") or {}
    for key in ("primary", "secondary"):
        limit = limits.get(key) or {}
        label = window_label(limit.get("window_minutes"))
        metric = percent_metric(label, limit.get("used_percent")) if label else None
        if metric is not None:
            metrics.append(metric)

    return {
        "title": "Codex",
        "symbol": "staroflife",
        "metricsBarValue": context["formattedValue"],
        "metrics": metrics,
        "lastUpdatedDate": now.astimezone(timezone.utc).strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        ),
    }


def write_snapshot(snapshot, destination):
    destination.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(
        prefix=".runcat-", dir=destination.parent
    )
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as stream:
            json.dump(snapshot, stream, ensure_ascii=False)
        os.replace(temporary, destination)
    except Exception:
        try:
            os.unlink(temporary)
        except OSError:
            pass
        raise


def main():
    try:
        hook = json.load(sys.stdin)
        transcript = Path(hook["transcript_path"])
        transcript_model, token_count = scan_transcript(transcript)
        snapshot = build_snapshot(
            hook.get("model") or transcript_model,
            token_count,
            datetime.now(timezone.utc),
        )
        if snapshot is not None:
            write_snapshot(snapshot, OUT)
    except Exception:
        pass
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
