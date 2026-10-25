package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LabItemModule implements IModule
   {
      
      private static var _instance:LabItemModule;
      
      public static const LABITEM_LASER:int = 0;
      
      public static const LABITEM_ROCKETS:int = 1;
      
      public static const LABITEM_DRIVING:int = 2;
      
      public static const LABITEM_SHIELD:int = 3;
      
      public static const LABITEM__MAX:int = 4;
      
      public var itemValue:int = 0;
      
      public function LabItemModule(param1:int = 0)
      {
         super();
         this.itemValue = param1;
      }
      
      public static function get instance() : LabItemModule
      {
         return _instance || (_instance = new LabItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 134;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(134);
         param1.writeShort(this.itemValue);
      }
   }
}

