package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DisassemblyRequest implements IModule
   {
      
      private static var _instance:DisassemblyRequest;
      
      public var recipeLootId:String = "";
      
      public var itemId:Number = 0;
      
      public function DisassemblyRequest(param1:String = "", param2:Number = 0)
      {
         super();
         this.recipeLootId = param1;
         this.itemId = param2;
      }
      
      public static function get instance() : DisassemblyRequest
      {
         return _instance || (_instance = new DisassemblyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12941;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.recipeLootId = param1.readUTF();
         this.itemId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12941);
         param1.writeUTF(this.recipeLootId);
         param1.writeDouble(this.itemId);
      }
   }
}

