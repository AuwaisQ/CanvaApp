class NameIdBean
{
  String id,name,image;
  bool status;
  NameIdBean(this.id,this.name,this.image,this.status);
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