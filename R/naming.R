# Binding basics ----------
library(lobstr)
mean_func <- list(mean, base::mean, get('mean'), evalq(mean), match.fun('mean'))
unique(obj_addrs(mean_func))

# Make name -----
# i can probably make a choice question to test their R-accepted name choice
make.names(c("a and b", "a-and-b"), unique=F)

# Copy-on-modify -----
# this seems to me odd compared to how it happen in other programming language
# we can also use tracemem(x) to keep track of address change of variable
a <- 1:10; b <- list(a, a)
c <- list(b, a, 1:10)
ref(c)

# Object size -----
funs <- list(mean, sd, var)
obj_size(funs)

# Environment function ----
environment(mean) #namespace:base
a <- ifelse(exists('a'), a, 1)
# R looks for value when function is run, not when function is created

# Function argument ---
args(obj_size)

# dot-dot-dot or dot-dot-N ----
