package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DropRequest implements IModule
   {
      
      private static var _instance:DropRequest;
      
      public static const DROPTYPE_FIREWORK:int = 0;
      
      public static const DROPTYPE_FIREWORK_1:int = 1;
      
      public static const DROPTYPE_FIREWORK_2:int = 2;
      
      public static const DROPTYPE_FIREWORK_3:int = 3;
      
      public static const DROPTYPE_MINE:int = 4;
      
      public static const DROPTYPE_MINE_EMP:int = 5;
      
      public static const DROPTYPE_MINE_SAB:int = 6;
      
      public static const DROPTYPE_MINE_DD:int = 7;
      
      public static const DROPTYPE_SMARTBOMB:int = 8;
      
      public static const DROPTYPE__MAX:int = 9;
      
      public var toDrop:int = 0;
      
      public function DropRequest(param1:int = 0)
      {
         super();
         this.toDrop = param1;
      }
      
      public static function get instance() : DropRequest
      {
         return _instance || (_instance = new DropRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 34;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.toDrop = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(34);
         param1.writeShort(this.toDrop);
      }
   }
}

