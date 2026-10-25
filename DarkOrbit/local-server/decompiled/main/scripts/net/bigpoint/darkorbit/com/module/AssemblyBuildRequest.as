package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyBuildRequest implements IModule
   {
      
      private static var _instance:AssemblyBuildRequest;
      
      public var targetItemId:Number = 0;
      
      public var amount:Number = 0;
      
      public var recipeLootId:String = "";
      
      public function AssemblyBuildRequest(param1:String = "", param2:Number = 0, param3:Number = 0)
      {
         super();
         this.targetItemId = param3;
         this.amount = param2;
         this.recipeLootId = param1;
      }
      
      public static function get instance() : AssemblyBuildRequest
      {
         return _instance || (_instance = new AssemblyBuildRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3034;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.targetItemId = param1.readDouble();
         this.amount = param1.readDouble();
         this.recipeLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3034);
         param1.writeDouble(this.targetItemId);
         param1.writeDouble(this.amount);
         param1.writeUTF(this.recipeLootId);
      }
   }
}

