package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BoosterDetailModule implements IModule
   {
      
      private static var _instance:BoosterDetailModule;
      
      public var lootId:String = "";
      
      public function BoosterDetailModule(param1:String = "")
      {
         super();
         this.lootId = param1;
      }
      
      public static function get instance() : BoosterDetailModule
      {
         return _instance || (_instance = new BoosterDetailModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -30703;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-30703);
         param1.writeUTF(this.lootId);
      }
   }
}

