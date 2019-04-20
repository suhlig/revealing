# Example

Given this markdown document (note the DITAA block) saved as `example.markdown`:

```markdown
The following graph shows two boxes, connected:

```ditaa
+-----+   +-----+
|  A  |-->|  B  |
+-----+   +-----+
 ```

As you can see, ditaa renders that quite pretty. It's turned into an embedded SVG.

```

The following command turns the DITAA block into SVG, embedded in the HTML:

```command
$ pandoc --lua-filter ditaa-inline.lua --out example.html example.markdown
```

The result looks like this:

![](example.png)
