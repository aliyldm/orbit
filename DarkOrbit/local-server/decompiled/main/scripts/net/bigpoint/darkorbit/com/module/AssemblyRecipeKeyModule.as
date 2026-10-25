package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeKeyModule implements IModule
   {
      
      private static var _instance:AssemblyRecipeKeyModule;
      
      public var lootId:String = "";
      
      public var targetId:Number = 0;
      
      public function AssemblyRecipeKeyModule(param1:String = "", param2:Number = 0)
      {
         super();
         this.lootId = param1;
         this.targetId = param2;
      }
      
      public static function get instance() : AssemblyRecipeKeyModule
      {
         return _instance || (_instance = new AssemblyRecipeKeyModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24391;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.targetId = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24391);
         param1.writeUTF(this.lootId);
         param1.writeDouble(this.targetId);
      }
   }
}

