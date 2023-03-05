---@meta

---
---This type definition is based on the [HTML documentation](http://www.inf.puc-rio.br/~roberto/lpeg/) of the LPeg library. A different HTML documentation can be found at http://stevedonovan.github.io/lua-stdlibs/modules/lpeg.html.
---
---*LPeg* is a new pattern-matching library for Lua,
---based on
---[Parsing Expression Grammars](https://bford.info/packrat/) (PEGs).
---This text is a reference manual for the library.
---For a more formal treatment of LPeg,
---as well as some discussion about its implementation,
---see
---[A Text Pattern-Matching Tool based on Parsing Expression Grammars](http://www.inf.puc-rio.br/~roberto/docs/peg.pdf).
---(You may also be interested in my
---[talk about LPeg](https://vimeo.com/1485123)
---given at the III Lua Workshop.)
---
---Following the Snobol tradition,
---LPeg defines patterns as first-class objects.
---That is, patterns are regular Lua values
---(represented by userdata).
---The library offers several functions to create
---and compose patterns.
---With the use of metamethods,
---several of these functions are provided as infix or prefix
---operators.
---On the one hand,
---the result is usually much more verbose than the typical
---encoding of patterns using the so called
---*regular expressions*
---(which typically are not regular expressions in the formal sense).
---On the other hand,
---first-class patterns allow much better documentation
---(as it is easy to comment the code,
---to break complex definitions in smaller parts, etc.)
---and are extensible,
---as we can define new functions to create and compose patterns.
local lpeg = {}

---
---@class Pattern
---@operator add(Pattern): Pattern
---@operator mul(Pattern): Pattern
---@operator mul(Capture): Pattern
---@operator pow(Pattern): Pattern
---@field match fun(p: Pattern, s: string)

---
---@class Capture
---@operator add(Capture): Pattern
---@operator mul(Capture): Pattern
---@operator mul(Pattern): Pattern
---@operator pow(Capture): Pattern
---
---The matching function.
---It attempts to match the given pattern against the subject string.
---If the match succeeds,
---returns the index in the subject of the first character after the match,
---or the captured values
---(if the pattern captured any value).
---
---An optional numeric argument `init` makes the match
---start at that position in the subject string.
---As usual in Lua libraries,
---a negative value counts from the end.
---
---Unlike typical pattern-matching functions,
---`match` works only in anchored mode;
---that is, it tries to match the pattern with a prefix of
---the given subject string (at position `init`),
---not with an arbitrary substring of the subject.
---So, if we want to find a pattern anywhere in a string,
---we must either write a loop in Lua or write a pattern that
---matches anywhere.
---This second approach is easy and quite efficient;
---@param pattern Pattern
---@param subject string
---@param init? integer
---
---@return integer|Capture
function lpeg.match(pattern, subject, init) end

---
---If the given value is a pattern,
---returns the string `"pattern"`.
---Otherwise returns nil.
---
---@return nil|string
function lpeg.type(value) end

---
---Returns a string with the running version of LPeg.
---
---@return string
function lpeg.version() end

---
---Sets a limit for the size of the backtrack stack used by LPeg to
---track calls and choices.
---(The default limit is 400.)
---Most well-written patterns need little backtrack levels and
---therefore you seldom need to change this limit;
---before changing it you should try to rewrite your
---pattern to avoid the need for extra space.
---Nevertheless, a few useful patterns may overflow.
---Also, with recursive grammars,
---subjects with deep recursion may also need larger limits.
---
---@param max integer
function lpeg.setmaxstack(max) end

---
---Converts the given value into a proper pattern,
---according to the following rules:
---
---* If the argument is a pattern,
---it is returned unmodified.
---
---* If the argument is a string,
---it is translated to a pattern that matches the string literally.
---
---* If the argument is a non-negative number n,
---the result is a pattern that matches exactly n characters.
---
---* If the argument is a negative number -n,
---the result is a pattern that
---succeeds only if the input string has less than ncharacters left:
---`lpeg.P(-n)`
---is equivalent to `-lpeg.P(n)`
---(see the  unary minus operation).
---
---* If the argument is a boolean,
---the result is a pattern that always succeeds or always fails
---(according to the boolean value),
---without consuming any input.
---
---* If the argument is a table,
---it is interpreted as a grammar
---(see Grammars).
---
---* If the argument is a function,
---returns a pattern equivalent to a
---match-time captureover the empty string.
---@param value Pattern|string|integer|boolean|table|function
---
---@return Pattern
function lpeg.P(value) end

---
---Returns a pattern that
---matches only if the input string at the current position
---is preceded by `patt`.
---Pattern `patt` must match only strings
---with some fixed length,
---and it cannot contain captures.
---
---Like the and predicate,
---this pattern never consumes any input,
---independently of success or failure.
---
---@param pattern Pattern
---
---@return Pattern
function lpeg.B(pattern) end

---
---Returns a pattern that matches any single character
---belonging to one of the given ranges.
---Each `range` is a string `xy` of length 2,
---representing all characters with code
---between the codes of `x` and `y`
---(both inclusive).
---
---As an example, the pattern
---`lpeg.R("09")` matches any digit,
---and `lpeg.R("az", "AZ")` matches any ASCII letter.
---
---@param ... string
---
---@return Pattern
function lpeg.R(...) end

---
---Returns a pattern that matches any single character that
---appears in the given string.
---(The `S` stands for Set.)
---
---As an example, the pattern
---`lpeg.S("+-*/")` matches any arithmetic operator.
---
---Note that, if `s` is a character
---(that is, a string of length 1),
---then `lpeg.P(s)` is equivalent to `lpeg.S(s)`
---which is equivalent to `lpeg.R(s..s)`.
---Note also that both `lpeg.S("")` and `lpeg.R()`
---are patterns that always fail.
---
---@param string string
---
---@return Pattern
function lpeg.S(string) end

---
---This operation creates a non-terminal (a variable)
---for a grammar.
---The created non-terminal refers to the rule indexed by `v`
---in the enclosing grammar.
---@param v string
---
---@return Pattern
function lpeg.V(v) end

---
---@class Locale
---@field alnum userdata
---@field alpha userdata
---@field cntrl userdata
---@field digit userdata
---@field graph userdata
---@field lower userdata
---@field print userdata
---@field punct userdata
---@field space userdata
---@field upper userdata
---@field xdigit userdata

---
---Returns a table with patterns for matching some character classes
---according to the current locale.
---The table has fields named
---`alnum`,
---`alpha`,
---`cntrl`,
---`digit`,
---`graph`,
---`lower`,
---`print`,
---`punct`,
---`space`,
---`upper`, and
---`xdigit`,
---each one containing a correspondent pattern.
---Each pattern matches any single character that belongs to its class.
--
---If called with an argument `table`,
---then it creates those fields inside the given table and
---returns that table.
---@param tab? table
---
---@return Locale
function lpeg.locale(tab) end

---
---Create a simple capture.
---
---Creates a simple capture,
---which captures the substring of the subject that matches `patt`.
---The captured value is a string.
---If `patt` has other captures,
---their values are returned after this one.
---@param patt Pattern
---
---@return Capture
function lpeg.C(patt) end

---
---Create an argument capture.
---
---This pattern matches the empty string and
---produces the value given as the nth extra
---argument given in the call to `lpeg.match`.
---
---@param n integer
---
---@return Capture
function lpeg.Carg(n) end

---
---Create a back capture.
---
---This pattern matches the empty string and
---produces the values produced by the most recent
---group capture named `name`
---(where `name` can be any Lua value).
---
---Most recent means the last
---complete
---outermost
---group capture with the given name.
---A Complete capture means that the entire pattern
---corresponding to the capture has matched.
---An Outermost capture means that the capture is not inside
---another complete capture.
---
---In the same way that LPeg does not specify when it evaluates captures,
---it does not specify whether it reuses
---values previously produced by the group
---or re-evaluates them.
---
---@param name any
---
---@return Capture
function lpeg.Cb(name) end

---
---Create a constant capture.
---
---This pattern matches the empty string and
---produces all given values as its captured values.
---
---@param ... any
---
---@return Capture
function lpeg.Cc(...) end

---
---Create a fold capture.
---
---If `patt` produces a list of captures
---C1 C2 ... Cn,
---this capture will produce the value
---`func(...func(func(C1, C2), C3)...,Cn)`,
---that is, it will fold
---(or accumulate, or reduce)
---the captures from `patt` using function `func`.
---
---This capture assumes that `patt` should produce
---at least one capture with at least one value (of any type),
---which becomes the initial value of an accumulator.
---(If you need a specific initial value,
---you may prefix a constant captureto `patt`.)
---For each subsequent capture,
---LPeg calls `func`
---with this accumulator as the first argument and all values produced
---by the capture as extra arguments;
---the first result from this call
---becomes the new value for the accumulator.
---The final value of the accumulator becomes the captured value.
---
---__Example:__
---
---```lua
----- matches a numeral and captures its numerical value
---number = lpeg.R"09"^1 / tonumber
---
----- matches a list of numbers, capturing their values
---list = number * ("," * number)^0
---
----- auxiliary function to add two numbers
---function add (acc, newvalue) return acc + newvalue end
---
----- folds the list of numbers adding them
---sum = lpeg.Cf(list, add)
---
----- example of use
---print(sum:match("10,30,43"))   --> 83
---```
---
---@param patt Pattern
---@param func fun(acc, newvalue)
---
---@return Capture
function lpeg.Cf(patt, func) end

---
---Create a group capture.
---
---It groups all values returned by `patt`
---into a single capture.
---The group may be anonymous (if no name is given)
---or named with the given name
---(which can be any non-nil Lua value).
---
---@param patt Pattern
---@param name? string
---
---@return Capture
function lpeg.Cg(patt, name) end

---
---Create a position capture.
---
---It matches the empty string and
---captures the position in the subject where the match occurs.
---The captured value is a number.
---
---@return Capture
function lpeg.Cp() end

---
---Creates a substitution capture.
---
---Creates a substitution capture,
---which captures the substring of the subject that matches `patt`,
---with substitutions.
---For any capture inside `patt` with a value,
---the substring that matched the capture is replaced by the capture value
---(which should be a string).
---The final captured value is the string resulting from
---all replacements.
---
---@param patt Pattern
---
---@return Capture
function lpeg.Cs(patt) end

---
---Create a table capture.
---
---This capture returns a table with all values from all anonymous captures
---made by `patt` inside this table in successive integer keys,
---starting at 1.
---Moreover,
---for each named capture group created by `patt`,
---the first value of the group is put into the table
---with the group name as its key.
---The captured value is only the table.
---
---@param patt Pattern|''
---
---@return Capture
function lpeg.Ct(patt) end

---
---Create a match-time capture.
---
---Unlike all other captures,
---this one is evaluated immediately when a match occurs
---(even if it is part of a larger pattern that fails later).
---It forces the immediate evaluation of all its nested captures
---and then calls `function`.
---
---The given function gets as arguments the entire subject,
---the current position (after the match of `patt`),
---plus any capture values produced by `patt`.
---
---The first value returned by `function`
---defines how the match happens.
---If the call returns a number,
---the match succeeds
---and the returned number becomes the new current position.
---(Assuming a subject sand current position i,
---the returned number must be in the range [i, len(s) + 1].)
---If the call returns true,
---the match succeeds without consuming any input.
---(So, to return trueis equivalent to return i.)
---If the call returns false, nil, or no value,
---the match fails.
---
---Any extra values returned by the function become the
---values produced by the capture.
---
---@param patt Pattern
---@param fn function
---
---@return Capture
function lpeg.Cmt(patt, fn) end

return lpeg
