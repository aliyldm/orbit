package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblySkipRequest implements IModule
   {
      
      private static var _instance:AssemblySkipRequest;
      
      public var recipeLootId:String = "";
      
      public var targetItemId:Number = 0;
      
      public function AssemblySkipRequest(param1:String = "", param2:Number = 0)
      {
         super();
         this.recipeLootId = param1;
         this.targetItemId = param2;
      }
      
      public static function get instance() : AssemblySkipRequest
      {
         return _instance || (_instance = new AssemblySkipRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -520;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.recipeLootId = param1.readUTF();
         this.targetItemId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-520);
         param1.writeUTF(this.recipeLootId);
         param1.writeDouble(this.targetItemId);
      }
   }
}

