package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeStatusUpdateCommand implements IModule
   {
      
      private static var _instance:AssemblyRecipeStatusUpdateCommand;
      
      public var targetItemId:Number = 0;
      
      public var status:AssemblyRecipeStatusModule;
      
      public var lootId:String = "";
      
      public function AssemblyRecipeStatusUpdateCommand(param1:String = "", param2:Number = 0, param3:AssemblyRecipeStatusModule = null)
      {
         super();
         this.targetItemId = param2;
         if(param3 == null)
         {
            this.status = new AssemblyRecipeStatusModule();
         }
         else
         {
            this.status = param3;
         }
         this.lootId = param1;
      }
      
      public static function get instance() : AssemblyRecipeStatusUpdateCommand
      {
         return _instance || (_instance = new AssemblyRecipeStatusUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29164;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.targetItemId = param1.readDouble();
         this.status = AssemblyRecipeStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.status)
         {
            this.status.read(param1);
         }
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29164);
         param1.writeDouble(this.targetItemId);
         if(null != this.status)
         {
            this.status.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.lootId);
      }
   }
}

