FROM ubuntu:18.04 as builder

RUN ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && echo "Etc/UTC" > /etc/timezone
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      texlive-fonts-recommended=2017.20180305-1 \
      texlive-plain-generic=2017.20180305-2 \
      texlive-latex-extra=2017.20180305-2 \
      ghostscript=9.26~dfsg+0-0ubuntu0.18.04.7 \
      imagemagick=8:6.9.7.4+dfsg-16ubuntu6.4 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /resume
COPY . /resume/
RUN pdflatex resume.tex

FROM nginx:1.15.7-alpine
COPY --from=builder /resume/resume.pdf /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80