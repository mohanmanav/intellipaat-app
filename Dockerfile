# Used Nginx image
FROM nginx:alpine

# Working directory inside the container
WORKDIR /usr/share/nginx/html

# Copy the HTML file to the Nginx default directory
COPY index.html /usr/share/nginx/html/

# Copy the images folder to the Nginx default directory
COPY images /usr/share/nginx/html/images/

# Expose port 80 for the web server
EXPOSE 85

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
