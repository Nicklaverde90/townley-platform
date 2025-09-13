# Multi-stage build for Vite React app
# Build stage
FROM node:22.12.0-alpine AS build
WORKDIR /app
# Install dependencies
COPY package.json package-lock.json* pnpm-lock.yaml* yarn.lock* ./
RUN set -eux;     if [ -f package-lock.json ]; then npm ci;     elif [ -f pnpm-lock.yaml ]; then corepack enable && pnpm i --frozen-lockfile;     elif [ -f yarn.lock ]; then yarn install --frozen-lockfile;     else npm i; fi
# Copy sources and build
COPY . .
RUN npm run build

# Export stage: copies built assets into a mounted volume at /out
FROM alpine:3.20
WORKDIR /export
COPY --from=build /app/dist /export
# On container start, copy the build to the mounted volume and keep the container alive
CMD sh -c "mkdir -p /out && cp -R /export/* /out/ && echo 'Frontend assets exported to /out' && tail -f /dev/null"
