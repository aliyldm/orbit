package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyCollectRequest implements IModule
   {
      
      private static var _instance:AssemblyCollectRequest;
      
      public var recipeLootId:String = "";
      
      public var targetItemId:Number = 0;
      
      public function AssemblyCollectRequest(param1:Number = 0, param2:String = "")
      {
         super();
         this.recipeLootId = param2;
         this.targetItemId = param1;
      }
      
      public static function get instance() : AssemblyCollectRequest
      {
         return _instance || (_instance = new AssemblyCollectRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20634;
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
         param1.writeShort(-20634);
         param1.writeUTF(this.recipeLootId);
         param1.writeDouble(this.targetItemId);
      }
   }
}

