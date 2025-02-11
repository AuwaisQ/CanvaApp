class TestNameIdBean
{
  String id,name,type,image;
  bool status;
  TestNameIdBean(this.id,this.name,this.type,this.image,this.status);
  setId(String id)
  {
    this.id=id;
  }

  setStatus(bool status)
  {
    this.status=status;
  }

  getStatus()
  {
    return this.status;
  }

// setAllStatus(String id)
// {
//
// }
}