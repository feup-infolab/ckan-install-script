# CKAN Install Scripts
A Bash script to (**partially**) automate [CKAN](http://ckan.org/) installation

**Don't just run the script!!**
It is intended as a record of an installation of CKAN 2.5 on Ubuntu Server 16.04.
Copy and paste every line while following the [tutorial](http://docs.ckan.org/en/latest/maintaining/installing/index.html).

Several minor (but important) changes had to be introduced to the tutorial for this Ubuntu distro, namely:

## Jetty

The config file is /etc/default/jetty8 instead of /etc/default/jetty

## Startup as a service

systemd script added to start [CKAN](http://ckan.org/) as a service. This is intended to allow the python virtualenv to be loaded on service startup.

## Monitoring CKAN

CKAN prints its output to the journal. To monitor, use the following command:

`sudo journalctl -f`

## Acknowledgements

This work was supported by project NORTE-07-0124-FEDER-000059, financed by the North Portugal Regional Operational Programme (ON.2-O Novo Norte), under the National Strategic Reference Framework (NSRF), through the European Regional Development Fund (ERDF), and by national funds, through the Portuguese funding agency, Fundação para a Ciência e a Tecnologia (FCT). João Rocha da Silva was also supported by research grant SFRH/BD/77092/2011, provided by the Portuguese funding agency, Fundação para a Ciência e a Tecnologia (FCT).

This work is financed by the ERDF – European Regional Development Fund through the Operational Programme for Competitiveness and Internationalisation - COMPETE 2020 Programme and by National Funds through the Portuguese funding agency, FCT - Fundação para a Ciência e a Tecnologia within project POCI-01-0145-FEDER-016736.

<img src="https://github.com/feup-infolab-rdm/dendro-install/raw/master/logos.jpg">

## License

All source code is freely available under a standard [BSD 3-Clause license](https://opensource.org/licenses/BSD-3-Clause).

Copyright (c) 2016, João Rocha da Silva, FEUP InfoLab (http://dendro.fe.up.pt)

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
