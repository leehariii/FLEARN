package org.flearn.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.TypedQuery;
import org.flearn.model.ClassRoom;

import java.util.List;

/**
 * Data Access Object for the ClassRoom entity.
 */
public class ClassDAO {

    public ClassRoom findById(int id) {
        EntityManager em = DBContext.getEntityManager();
        try {
            return em.find(ClassRoom.class, id);
        } finally {
            em.close();
        }
    }

    public List<ClassRoom> findAll() {
        EntityManager em = DBContext.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM ClassRoom c WHERE c.isActive = true ORDER BY c.createdAt DESC",
                    ClassRoom.class).getResultList();
        } finally {
            em.close();
        }
    }

    public List<ClassRoom> findByTeacher(int teacherId) {
        EntityManager em = DBContext.getEntityManager();
        try {
            TypedQuery<ClassRoom> query = em.createQuery(
                    "SELECT c FROM ClassRoom c WHERE c.teacher.userId = :teacherId AND c.isActive = true ORDER BY c.createdAt DESC",
                    ClassRoom.class);
            query.setParameter("teacherId", teacherId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public ClassRoom findByInviteCode(String code) {
        EntityManager em = DBContext.getEntityManager();
        try {
            TypedQuery<ClassRoom> query = em.createQuery(
                    "SELECT c FROM ClassRoom c WHERE c.inviteCode = :code", ClassRoom.class);
            query.setParameter("code", code);
            List<ClassRoom> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }

    public void save(ClassRoom classRoom) {
        EntityManager em = DBContext.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(classRoom);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void update(ClassRoom classRoom) {
        EntityManager em = DBContext.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(classRoom);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void delete(int id) {
        EntityManager em = DBContext.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            ClassRoom classRoom = em.find(ClassRoom.class, id);
            if (classRoom != null) {
                em.remove(classRoom);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
