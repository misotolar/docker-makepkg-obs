FROM misotolar/makepkg:base-devel-20240514.0.236051

LABEL maintainer="michal@sotolar.com"

COPY resources/oscrc /home/build/.config/osc/oscrc

RUN set -ex; \
    sudo chmod 0700 /home/build/.config/osc; \
    sudo chown -R build:build /home/build/.config/osc; \
    yay -S --noconfirm --removemake python-urllib3 osc rsync;

COPY makepkg.sh /usr/local/bin/makepkg.sh

ENTRYPOINT ["makepkg.sh"]
