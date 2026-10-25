package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RemoveMinimapMark implements IModule
   {
      
      private static var _instance:RemoveMinimapMark;
      
      public var uid:String = "";
      
      public function RemoveMinimapMark(param1:String = "")
      {
         super();
         this.uid = param1;
      }
      
      public static function get instance() : RemoveMinimapMark
      {
         return _instance || (_instance = new RemoveMinimapMark());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4195;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.uid = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4195);
         param1.writeUTF(this.uid);
      }
   }
}

