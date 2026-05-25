<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.persistence.EntityManager" %>
<%@ page import="jakarta.persistence.EntityTransaction" %>
<%@ page import="org.flearn.dao.DBContext" %>
<%@ page import="org.flearn.model.*" %>
<%@ page import="org.flearn.util.AppConstants" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>FLearn Test Data Seeder</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body class="bg-dark text-light py-5">
<div class="container" style="max-width: 700px;">
    <div class="card bg-secondary text-light p-4 shadow-lg">
        <h2 class="text-center text-warning mb-4"><i class="fas fa-database me-2"></i> FLearn Seeder Dữ Liệu Thử Nghiệm
        </h2>

        <%
            User student = (User) session.getAttribute("loggedInUser");
            if (student == null) {
        %>
        <div class="alert alert-danger text-center">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Bạn chưa đăng nhập!</strong><br/>
            Vui lòng <a href="login" class="alert-link">Đăng nhập tài khoản Học viên</a> trước để hệ thống biết gắn tiến
            trình bài học cho ai nhé.
        </div>
        <%
        } else {
            EntityManager em = DBContext.getEntityManager();
            EntityTransaction tx = em.getTransaction();
            try {
                tx.begin();

                // Find or create a teacher for the courses
                User teacher = null;
                List<User> teachers = em.createQuery("SELECT u FROM User u WHERE u.role = 1", User.class).getResultList();
                if (!teachers.isEmpty()) {
                    teacher = teachers.get(0);
                } else {
                    // Create a dummy teacher
                    teacher = User.builder()
                            .username("teacher_test")
                            .passwordHash("teacher123")
                            .fullName("Thầy Nguyễn Văn Giảng")
                            .email("giangvien@flearn.edu.vn")
                            .role(AppConstants.ROLE_TEACHER)
                            .isActive(true)
                            .createdAt(LocalDateTime.now())
                            .build();
                    em.persist(teacher);
                }

                // ==========================================
                // 1. CREATE COMPLETED COURSE (100% Progress)
                // ==========================================
                ClassRoom completedClass = ClassRoom.builder()
                        .teacher(teacher)
                        .className("Lớp học Flipped Classroom Mẫu - F8")
                        .inviteCode("FC100")
                        .isActive(true)
                        .createdAt(LocalDateTime.now())
                        .build();
                em.persist(completedClass);

                // Add Student as Class Member
                ClassMember cm1 = ClassMember.builder()
                        .classRoom(completedClass)
                        .student(student)
                        .joinedAt(LocalDateTime.now())
                        .build();
                em.persist(cm1);

                // Add 3 Nodes (Video, Quiz, Milestone)
                Node n1 = Node.builder()
                        .classRoom(completedClass)
                        .title("Bài 1: Giới thiệu mô hình lớp học đảo ngược (Flipped Classroom)")
                        .videoUrl("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
                        .orderIndex(1)
                        .nodeType(AppConstants.NODE_VIDEO)
                        .isActive(true)
                        .build();
                em.persist(n1);

                Node n2 = Node.builder()
                        .classRoom(completedClass)
                        .title("Bài kiểm tra kiến thức Flipped Classroom")
                        .orderIndex(2)
                        .nodeType(AppConstants.NODE_QUIZ)
                        .isActive(true)
                        .build();
                em.persist(n2);

                Node n3 = Node.builder()
                        .classRoom(completedClass)
                        .title("Báo cáo Milestone 1: Thiết kế kế hoạch tự học")
                        .orderIndex(3)
                        .nodeType(AppConstants.NODE_MILESTONE)
                        .isActive(true)
                        .build();
                em.persist(n3);

                // Add Completed Student Progress for all 3 nodes
                StudentProgress sp1 = StudentProgress.builder()
                        .student(student)
                        .node(n1)
                        .isCompleted(true)
                        .lastWatchedSec(180)
                        .totalBonus(10)
                        .updatedAt(LocalDateTime.now())
                        .build();
                em.persist(sp1);

                StudentProgress sp2 = StudentProgress.builder()
                        .student(student)
                        .node(n2)
                        .isCompleted(true)
                        .lastWatchedSec(0)
                        .totalBonus(20)
                        .updatedAt(LocalDateTime.now())
                        .build();
                em.persist(sp2);

                StudentProgress sp3 = StudentProgress.builder()
                        .student(student)
                        .node(n3)
                        .isCompleted(true)
                        .lastWatchedSec(0)
                        .totalBonus(30)
                        .updatedAt(LocalDateTime.now())
                        .build();
                em.persist(sp3);

                // ==========================================
                // 2. CREATE IN-PROGRESS COURSE (33% Progress)
                // ==========================================
                ClassRoom ipClass = ClassRoom.builder()
                        .teacher(teacher)
                        .className("Lớp thiết kế Web UI/UX chuyên sâu")
                        .inviteCode("UIUX50")
                        .isActive(true)
                        .createdAt(LocalDateTime.now())
                        .build();
                em.persist(ipClass);

                // Add Student as Class Member
                ClassMember cm2 = ClassMember.builder()
                        .classRoom(ipClass)
                        .student(student)
                        .joinedAt(LocalDateTime.now())
                        .build();
                em.persist(cm2);

                // Add 3 Nodes
                Node n4 = Node.builder()
                        .classRoom(ipClass)
                        .title("Bài 1: Thiết kế giao diện với Figma cơ bản")
                        .videoUrl("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
                        .orderIndex(1)
                        .nodeType(AppConstants.NODE_VIDEO)
                        .isActive(true)
                        .build();
                em.persist(n4);

                Node n5 = Node.builder()
                        .classRoom(ipClass)
                        .title("Bài 2: Hướng dẫn Grid Layout & Flexbox")
                        .videoUrl("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
                        .orderIndex(2)
                        .nodeType(AppConstants.NODE_VIDEO)
                        .isActive(true)
                        .build();
                em.persist(n5);

                Node n6 = Node.builder()
                        .classRoom(ipClass)
                        .title("Bài trắc nghiệm về kiến thức UI/UX")
                        .orderIndex(3)
                        .nodeType(AppConstants.NODE_QUIZ)
                        .isActive(true)
                        .build();
                em.persist(n6);

                // Complete ONLY 1 node out of 3 (n4 completed, n5 & n6 not completed)
                StudentProgress sp4 = StudentProgress.builder()
                        .student(student)
                        .node(n4)
                        .isCompleted(true)
                        .lastWatchedSec(250)
                        .totalBonus(10)
                        .updatedAt(LocalDateTime.now())
                        .build();
                em.persist(sp4);

                tx.commit();
        %>
        <div class="alert alert-success text-center mb-4">
            <i class="fas fa-check-circle fa-2x mb-2 d-block"></i>
            <strong>Đã nạp dữ liệu thử nghiệm thành công!</strong>
        </div>

        <div class="mb-4">
            <h5>Dữ liệu được nạp vào tài khoản: <span class="text-warning"><%= student.getFullName() %></span></h5>
            <ul class="list-group list-group-flush bg-secondary text-light rounded border border-light">
                <li class="list-group-item bg-dark text-light d-flex justify-content-between align-items-center">
                    <strong>Lớp học Flipped Classroom Mẫu - F8</strong>
                    <span class="badge bg-success">100% Hoàn thành (3/3 bài học)</span>
                </li>
                <li class="list-group-item bg-dark text-light d-flex justify-content-between align-items-center">
                    <strong>Lớp thiết kế Web UI/UX chuyên sâu</strong>
                    <span class="badge bg-primary">33% Đang học (1/3 bài học)</span>
                </li>
            </ul>
        </div>

        <div class="d-grid gap-2">
            <a href="my-courses" class="btn btn-warning"><i class="fas fa-book-reader me-2"></i>Xem Khóa học của tôi</a>
            <a href="certificates" class="btn btn-success"><i class="fas fa-award me-2"></i>Xem Kho chứng chỉ</a>
        </div>
        <%
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
        %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle me-2"></i>
            <strong>Lỗi khi nạp dữ liệu:</strong> <%= e.getMessage() %>
            <% e.printStackTrace(); %>
        </div>
        <%
                } finally {
                    em.close();
                }
            }
        %>

    </div>
</div>
</body>
</html>
