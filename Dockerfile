FROM ubuntu:16.04

RUN apt update && \
	apt install -y git libboost-all-dev autoconf automake autotools-dev libtool zlib1g-dev cmake build-essential python3 python3-pip wget && \
	pip3 install nltk

RUN git clone https://github.com/delihiros/pseudogen.git && \
	cd pseudogen && \
	./tool_setup.sh && \
	mkdir data && \
	cd data && \
	wget -O- http://ahclab.naist.jp/pseudogen/en-django.tar.gz | tar zxvf - && \
	mv en-django/all.* . && \
	../train-pseudogen.sh -p all.code -e all.anno
