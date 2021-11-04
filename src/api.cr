require "./libs/cblas"
require "./libs/lapack"
require "./libs/clblast"
require "./libs/nnpack"

require "complex"

require "./extensions/array"
require "./extensions/number"

require "./tensor/internal/shape"
require "./tensor/internal/broadcast"
require "./tensor/internal/print"
require "./tensor/internal/enums"
require "./tensor/internal/random"

require "./tensor/data_structure"
require "./tensor/allocation"
require "./tensor/iteration"
require "./tensor/index"
require "./tensor/manipulate"
require "./tensor/math"
require "./tensor/convert"
require "./tensor/random"
require "./tensor/reduction"

require "./tensor/backends/util_storage"
require "./tensor/backends/util_manipulate"
require "./tensor/backends/util_index"

require "./tensor/backends/hostptr/unsafe_iter"
require "./tensor/backends/hostptr/yield_iterators"
require "./tensor/backends/hostptr/ndindex"

require "./tensor/backends/cpu/impl_allocation"
require "./tensor/backends/cpu/impl_manipulate"
require "./tensor/backends/cpu/impl_iteration"
require "./tensor/backends/cpu/impl_index"
require "./tensor/backends/cpu/impl_math"
require "./tensor/backends/cpu/impl_data_structure"
require "./tensor/backends/cpu/impl_convert"
require "./tensor/backends/cpu/impl_reduction"

require "./tensor/backends/opencl/kernels/base"
require "./tensor/backends/opencl/kernels/templates"
require "./tensor/backends/opencl/kernels/custom"
require "./tensor/backends/opencl/kernels/operators"
require "./tensor/backends/opencl/kernels/builtin"
require "./tensor/backends/opencl/private/global_state"
require "./tensor/backends/opencl/impl_allocation"
require "./tensor/backends/opencl/impl_data_structure"
require "./tensor/backends/opencl/impl_convert"
require "./tensor/backends/opencl/impl_math"
require "./tensor/backends/opencl/impl_index"
require "./tensor/backends/opencl/impl_manipulate"
require "./tensor/backends/opencl/impl_iteration"
require "./tensor/backends/opencl/impl_reduction"

require "./io/npy"

require "./linalg/extension"
require "./linalg/work"
require "./linalg/linalg"

require "./grad/primitives/context"
require "./grad/primitives/gate"
require "./grad/primitives/node"
require "./grad/primitives/payload"
require "./grad/primitives/variable"
require "./grad/gates/arithmetic"
require "./grad/gates/blas"
require "./grad/gates/exp"
require "./grad/gates/trigonometric"
require "./grad/backends/agnostic"
require "./grad/backends/cpu"
require "./grad/backends/opencl"
require "./grad/variable.cr"

require "./nn/primitives/layer"
require "./nn/primitives/loss"
require "./nn/primitives/optimizer"
require "./nn/primitives/validation"

require "./nn/datasets/datasets"
require "./nn/datasets/iris"
require "./nn/datasets/mnist"
require "./nn/initialization"
require "./nn/network"

require "./nn/gates/convolution"
require "./nn/gates/dropout"
require "./nn/gates/flatten"
require "./nn/gates/input"
require "./nn/gates/leaky_relu"
require "./nn/gates/linear"
require "./nn/gates/maxpool"
require "./nn/gates/mse"
require "./nn/gates/relu"
require "./nn/gates/sigmoid_cross_entropy"
require "./nn/gates/sigmoid"
require "./nn/gates/softmax_cross_entropy"

require "./nn/layers/convolution"
require "./nn/layers/dropout"
require "./nn/layers/flatten"
require "./nn/layers/input"
require "./nn/layers/leaky_relu"
require "./nn/layers/linear"
require "./nn/layers/maxpool"
require "./nn/layers/relu"
require "./nn/layers/sigmoid"

require "./nn/loss/mse"
require "./nn/loss/sigmoid_cross_entropy"
require "./nn/loss/softmax_cross_entropy"

require "./nn/optimizers/sgd"
require "./nn/optimizers/adam"

require "./nn/backends/cpu/activation"
require "./nn/backends/cpu/convolution"
require "./nn/backends/cpu/loss"
require "./nn/backends/cpu/maxpool"
require "./nn/backends/cpu/dropout"
require "./nn/backends/cpu/optimizers"

require "./nn/backends/opencl/kernels/loss"
require "./nn/backends/opencl/kernels/optimizers"
require "./nn/backends/opencl/kernels/activation"
require "./nn/backends/opencl/activation"
require "./nn/backends/opencl/dropout"
require "./nn/backends/opencl/loss"
require "./nn/backends/opencl/optimizers"

require "./num/exceptions"
require "./num/aliases"

require "./einsum/contractors/pair"
require "./einsum/contractors/singleton"
require "./einsum/contractors/utils"
require "./einsum/contractors/contract"
require "./einsum/validation"
require "./einsum/optimizers"
require "./einsum/strategies"
