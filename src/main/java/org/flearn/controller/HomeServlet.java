package org.flearn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.flearn.util.AppConstants;

import java.io.IOException;

/**
 * Handles the home page request.
 * URL pattern: / or /home
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set page title for header.jsp
        request.setAttribute("pageTitle", "FLearn - Nền tảng học trực tuyến");
        request.setAttribute("activePage", "home");

        request.getRequestDispatcher(AppConstants.VIEW_HOME).forward(request, response);
    }
}
