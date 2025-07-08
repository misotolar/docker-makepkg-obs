FROM misotolar/makepkg:base-devel-20250706.0.377547

LABEL org.opencontainers.image.url="https://github.com/misotolar/docker-makepkg-obs"
LABEL org.opencontainers.image.description="Arch Linux OBS build environment"
LABEL org.opencontainers.image.authors="Michal Sotolar <michal@sotolar.com>"

COPY resources/config/oscrc /home/build/.config/osc/oscrc
COPY resources/makepkg.sh /usr/local/bin/makepkg.sh

RUN set -ex; \
    sudo chmod 0700 /home/build/.config/osc; \
    sudo chown -R build:build /home/build/.config/osc; \
    yay -S --noconfirm --removemake python-urllib3 osc rsync;

ENTRYPOINT ["makepkg.sh"]
