package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeSelectRequest implements IModule
   {
      
      private static var _instance:AssemblyRecipeSelectRequest;
      
      public var recipeLootId:String = "";
      
      public function AssemblyRecipeSelectRequest(param1:String = "")
      {
         super();
         this.recipeLootId = param1;
      }
      
      public static function get instance() : AssemblyRecipeSelectRequest
      {
         return _instance || (_instance = new AssemblyRecipeSelectRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24397;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.recipeLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24397);
         param1.writeUTF(this.recipeLootId);
      }
   }
}

