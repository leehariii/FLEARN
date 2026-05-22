package org.flearn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.flearn.dao.UserDAO;
import org.flearn.model.User;
import org.flearn.util.AppConstants;

import java.io.IOException;

/**
 * Handles user authentication (Login / Logout).
 * URL pattern: /login
 */
@WebServlet(name = "LoginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check for logout action
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // If already logged in, redirect to home
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(AppConstants.SESSION_USER) != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        request.setAttribute("pageTitle", "Đăng nhập - FLearn");
        request.setAttribute("activePage", "login");
        request.getRequestDispatcher(AppConstants.VIEW_LOGIN).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Simple authentication (password stored as hash in DB)
        User user = userDAO.authenticate(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute(AppConstants.SESSION_USER, user);
            session.setMaxInactiveInterval(AppConstants.SESSION_TIMEOUT_MINUTES * 60);
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
            request.setAttribute("pageTitle", "Đăng nhập - FLearn");
            request.setAttribute("activePage", "login");
            request.getRequestDispatcher(AppConstants.VIEW_LOGIN).forward(request, response);
        }
    }
}
