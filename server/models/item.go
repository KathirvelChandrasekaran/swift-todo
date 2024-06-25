package models

type Item struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	IsCompleted string `json:"isCompleted"`
}
