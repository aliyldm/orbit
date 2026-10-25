package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCCooldownValueModule extends CCValueModule
   {
      
      private static var _instance:CCCooldownValueModule;
      
      public var cdCom:String = "";
      
      public function CCCooldownValueModule(param1:String = "", param2:String = "")
      {
         super(param1);
         this.cdCom = param2;
      }
      
      public static function get instance() : CCCooldownValueModule
      {
         return _instance || (_instance = new CCCooldownValueModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 23412;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.cdCom = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23412);
         super.write(param1);
         param1.writeUTF(this.cdCom);
      }
   }
}

