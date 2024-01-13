# Use a specific version of node based on your application requirements
FROM node:18-alpine as base

# Builder stage
FROM base as builder

# Set the working directory
WORKDIR /home/node

# Copy package.json and yarn.lock (or package-lock.json if using npm)
COPY package.json yarn.lock ./

# Copy the rest of your code
COPY . .

# Install dependencies and build the application
RUN yarn install
RUN yarn build

# Runtime stage
FROM base as prod

# Set NODE_ENV to production
ENV NODE_ENV=production

# Set the working directory
WORKDIR /home/node

# Copy package.json, yarn.lock, and other necessary files for production
COPY package.json yarn.lock ./

# Install only production dependencies
RUN yarn install --production

# Copy built assets from the builder stage
COPY --from=builder /home/node/dist ./dist

# Expose the port your app runs on
EXPOSE 3000

# Start the application
CMD ["node", "dist/server.js"]
