
// excerpt
class Excerpt {
  id: string
  tag: {
    id: string,
    content: string,
    head: string
  }
  content: {
    content: string
    head: string
    tag: string
    time: string
  }
  comment: [{
    time: string
    content: string
  }]
}