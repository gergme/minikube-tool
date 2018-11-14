## Minikube Tool
`!WARNING!` This project is not complete and currently does not fully function, use at your own risk!

```
options:
-h, --help				Its what youre looking at!
-b, --backup			Backup the minikube virtual machine (not functional)
-d, --default-kube		Use the minikube default kubernetes version of v1.10.0
-r, --restore [file]	Restore a minikube virtual machine (!causes minikube corruption!)
-v, --version			Show version
--run					Run the script
```

### Project Description

This project aims to be a Minikube management tool allowing you to easily maintain complete minikube kubernetes installations, including backup, restore, experiment with using different versions of kubernetes (including RC).

### Options Description

| Option | Description |
|--------|--------|
|-h, --help|Displays all options and a short description of their functions |
|-b, --backup|Compresses the minikube directory into a gzipped tar file named with this date format YYYYMMDD-HHMM-SS|
|-d, --default-kube|Uses the minikube default kubernetes version, which may not always be latest stable|
|-r, --restore [file]|Decompresses a minikube backup and restore environments|
|-v, --version|Show the version of minikube-tool|
|--run|Deletes the current minikube installation (if it exists) and reinstalls minikube using defaults unless otherwise modified|

### License

MIT License

Copyright (c)2018 gergme

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
