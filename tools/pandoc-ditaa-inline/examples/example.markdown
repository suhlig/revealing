The following graph shows two boxes, connected:

```ditaa
+-----+   +-----+
|  A  |-->|  B  |
+-----+   +-----+
```

The `scale` attribute can be set so that the generated image is scaled by this factor. This requires the use of [fenced code attributes](https://pandoc.org/MANUAL.html#extension-fenced_code_attributes), where the class is written as `.ditaa`.

This is the same image as before, but scaled by factor `1.5`:

```{.ditaa scale=1.5}
+-----+   +-----+
|  A  |-->|  B  |
+-----+   +-----+
```

Other blocks are left untouched:

```ruby
puts "olleH".reverse
```

That's it!
