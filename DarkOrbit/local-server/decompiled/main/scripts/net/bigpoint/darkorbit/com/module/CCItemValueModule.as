package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCItemValueModule extends CCValueModule
   {
      
      private static var _instance:CCItemValueModule;
      
      public var lootId:String = "";
      
      public function CCItemValueModule(param1:String = "", param2:String = "")
      {
         super(param1);
         this.lootId = param2;
      }
      
      public static function get instance() : CCItemValueModule
      {
         return _instance || (_instance = new CCItemValueModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -12406;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.lootId = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12406);
         super.write(param1);
         param1.writeUTF(this.lootId);
      }
   }
}

