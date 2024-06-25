package main

import (
	"github.com/KathirvelChandrasekaran/swift-todo/controllers"
	"github.com/KathirvelChandrasekaran/swift-todo/models"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	models.ConnectDatabase()
	r.GET("/items", controllers.FindItems)
	r.POST("/items", controllers.CreateItem)
	r.GET("/items/:id", controllers.FindItem)
	r.PATCH("/items/:id", controllers.UpdateItem)
	r.DELETE("/items/:id", controllers.DeleteItem)

	r.Run()
}
