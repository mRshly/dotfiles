import attrs from 'markdown-it-attrs';
import container from 'markdown-it-container';
import mark from 'markdown-it-mark';

// ref: https://github.com/marp-team/marp-cli?tab=readme-ov-file#example-markdown-it-mark
//
/** 
 * @type {import('@marp-team/marp-cli').Config<typeof import('@marp-team/marpit').Marpit>["engine"]}
 */
export default ({ marp }) => marp
  .use(mark)
  .use(attrs)
  .use(container, 'name');

