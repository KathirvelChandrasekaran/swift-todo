package models

type Item struct {
	ID          uint   `json:"id" gorm:"primary_key"`
	Title       string `json:"title"`
	IsCompleted string `json:"isCompleted"`
}
