package net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo
{
   public class BoxesVo
   {
      
      public var rateId:String;
      
      public var itemList:Vector.<String> = new Vector.<String>();
      
      public function BoxesVo()
      {
         super();
      }
      
      public function add(param1:String) : void
      {
         this.itemList.push(param1);
      }
   }
}

