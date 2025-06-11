# Livrariajava

Livrariajava (“Livraria Mil Páginas”) is a demo bookstore built with Java Servlets and JSP. It shows how to organize controllers, DAOs, models and views in a simple Servlet-based project.

## Setup

1. **JDK 21** – install a Java 21 JDK and make sure `JAVA_HOME` points to it.
2. **Apache Tomcat** – deploy the project to Tomcat 9 or newer. Configure a JNDI `DataSource` named `jdbc/livraria` for the database that stores the application data.
3. **IDE (optional)** – the project can be imported into Eclipse as a *Dynamic Web Project* to easily build and export a WAR file. You can also compile the sources manually and place the compiled classes under `WEB-INF/classes`.

## Running

1. Start Tomcat with the above `DataSource` configured.
2. Deploy the generated WAR or the project directory to the Tomcat `webapps` folder.
3. Access `http://localhost:8080/livrariajava` in your browser to use the application.

This is a minimal code base primarily for study purposes, so some features may be incomplete.
