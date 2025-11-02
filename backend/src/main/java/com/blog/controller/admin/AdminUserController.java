package com.blog.controller.admin;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.blog.common.Result;
import com.blog.entity.User;
import com.blog.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;

/**
 * 用户管理控制器（后台）
 */
@Tag(name = "用户管理（后台）")
@RestController
@RequestMapping("/admin/user")
public class AdminUserController {
    
    private final UserService userService;
    
    public AdminUserController(UserService userService) {
        this.userService = userService;
    }
    
    /**
     * 分页查询用户列表
     */
    @Operation(summary = "分页查询用户列表")
    @GetMapping("/list")
    public Result<Page<User>> list(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<User> page = new Page<>(current, size);
        return Result.success(userService.page(page));
    }
    
    /**
     * 更新用户状态
     */
    @Operation(summary = "更新用户状态")
    @PutMapping("/status")
    public Result<?> updateStatus(@RequestBody User user) {
        try {
            userService.updateById(user);
            return Result.success("更新成功", null);
        } catch (Exception e) {
            return Result.error("更新失败：" + e.getMessage());
        }
    }
    
    /**
     * 删除用户
     */
    @Operation(summary = "删除用户")
    @DeleteMapping("/{id}")
    public Result<?> delete(@PathVariable Long id) {
        try {
            userService.removeById(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            return Result.error("删除失败：" + e.getMessage());
        }
    }
}


