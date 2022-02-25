ARG BUILDIMG=registry.access.redhat.com/ubi8/go-toolset
ARG RUNIMG=registry.access.redhat.com/ubi8-minimal

# ---------------------------------------
# build image
FROM ${BUILDIMG} as buildimg

WORKDIR /vuln4shift

USER root
RUN chown 1001 /vuln4shift

USER 1001

ADD go.mod                      /vuln4shift/
ADD main.go                     /vuln4shift/
ADD go.mod                      /vuln4shift/
ADD go.sum                      /vuln4shift/
ADD base                        /vuln4shift/base
ADD base/logging                /vuln4shift/base/logging
ADD base/utils                  /vuln4shift/base/utils
ADD dbadmin                     /vuln4shift/dbadmin
ADD manager                     /vuln4shift/manager
ADD manager/controllers         /vuln4shift/manager/controllers
ADD manager/controllers/meta    /vuln4shift/manager/controllers/meta
ADD manager/middlewares         /vuln4shift/manager/middlewares
ADD main.go                     /vuln4shift/

RUN go mod download
RUN go build -v main.go

# ---------------------------------------
# runtime image
FROM ${RUNIMG} as runtimeimg

WORKDIR /vuln4shift
USER 1001

COPY --from=buildimg /vuln4shift/main /vuln4shift/
