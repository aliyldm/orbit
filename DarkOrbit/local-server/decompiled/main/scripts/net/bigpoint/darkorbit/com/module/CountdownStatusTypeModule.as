package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CountdownStatusTypeModule implements IModule
   {
      
      private static var _instance:CountdownStatusTypeModule;
      
      public static const STATUSTYPE_HALLOWEEN_2012:int = 0;
      
      public static const STATUSTYPE__MAX:int = 1;
      
      public var type:int = 0;
      
      public function CountdownStatusTypeModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : CountdownStatusTypeModule
      {
         return _instance || (_instance = new CountdownStatusTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4714;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4714);
         param1.writeShort(this.type);
      }
   }
}

