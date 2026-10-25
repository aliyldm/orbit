package net.bigpoint.darkorbit.items.item.vo
{
   import net.bigpoint.darkorbit.fui.system.manager.IAcceptedType;
   
   public class AcceptedType implements IAcceptedType
   {
      
      private var _classname:String;
      
      public function AcceptedType()
      {
         super();
      }
      
      public function get group() : String
      {
         var _loc1_:String = "";
         if(this.classname != null)
         {
            _loc1_ = this.classname.substring(this.classname.lastIndexOf(".") + 1);
         }
         return _loc1_;
      }
      
      public function get type() : String
      {
         var _loc1_:String = "";
         if(this.classname != null)
         {
            _loc1_ = this.classname.split(".")[3];
         }
         return _loc1_;
      }
      
      public function get classname() : String
      {
         return this._classname;
      }
      
      public function set classname(param1:String) : void
      {
         this._classname = param1;
      }
   }
}

