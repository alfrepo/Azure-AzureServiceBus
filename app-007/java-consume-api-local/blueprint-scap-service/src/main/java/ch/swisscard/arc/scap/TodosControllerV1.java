package ch.swisscard.arc.scap;

import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import lombok.Value;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Slf4j
@RestController
@RequestMapping("/api/v1/user")
@CrossOrigin
@RequiredArgsConstructor
public class TodosControllerV1 {

    @Value
    @Builder(toBuilder = true)
    public static class TodoItem {
        String id;
        String name;
        boolean completed;
    }

    @Value
    @Builder(toBuilder = true)
    public static class Response {
        String message;

        static Response OK = new Response("success");
    }

    final ConcurrentMap<String, TodoItem> todoItems = new ConcurrentHashMap<>();

    @GetMapping("/todos")
    public ResponseEntity<List<TodoItem>> getTodos() {
        log.info("GET /todos");

        return ResponseEntity.ok().body(List.copyOf(todoItems.values()));
    }

    @PutMapping("/todos/{id}")
    public ResponseEntity<Response> putTodo(@PathVariable String id, @RequestBody TodoItem todoItem) throws JsonProcessingException {
        log.info("PUT - id={}, todo={}", id, todoItem);

        todoItems.put(id, todoItem);

        return ResponseEntity.ok().body(Response.OK);
    }

    @PostMapping("/todos")
    public ResponseEntity<Response> postTodo(@RequestBody TodoItem todoItem) throws JsonProcessingException {
        log.info("POST - todo={}", todoItem);

        todoItems.put(todoItem.getId(), todoItem);

        return ResponseEntity.ok().body(Response.OK);
    }

    @DeleteMapping("/todos/{id}")
    public ResponseEntity<Response> deleteTodo(@PathVariable String id) throws JsonProcessingException {
        log.info("DELETE - id={}");

        todoItems.remove(id);

        return ResponseEntity.ok().body(Response.OK);
    }
}