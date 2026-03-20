FROM node:20.11-alpine

WORKDIR /app

# Copy only package files
COPY package*.json ./

# Install production dependencies
RUN npm ci --production && \
    npm cache clean --force

# Copy application files
COPY . .

EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Run as non-root user
USER node

CMD ["node", "index.js"]