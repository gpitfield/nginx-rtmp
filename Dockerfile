FROM gpitfield/ffmpeg
ENV dir /usr/local
WORKDIR ${dir}
RUN git clone --depth 1 git://github.com/arut/nginx-rtmp-module.git \
&& curl -O http://nginx.org/download/nginx-1.8.0.tar.gz \
&& tar xzvf nginx-1.8.0.tar.gz
WORKDIR nginx-1.8.0
RUN ./configure --add-module=${dir}/nginx-rtmp-module \
&& make && make install \
&& cp /usr/local/nginx-rtmp-module/stat.xsl /usr/local/nginx/html/ \
&& rm -rf nginx-*
WORKDIR ${dir}
COPY ./files/mime.types /etc/mime.types
RUN ln -s ${dir}/nginx/sbin/nginx /usr/sbin/nginx
EXPOSE 80 1935
RUN yum install -y gettext
# comment to trigger rebuild
CMD ["nginx", "-g", "daemon off;"]
