package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeModule implements IModule
   {
      
      private static var _instance:AssemblyRecipeModule;
      
      public var recipeLootId:String = "";
      
      public var targetItemId:Number = 0;
      
      public var type:AssemblyRecipeTypeModule;
      
      public var status:AssemblyRecipeStatusModule;
      
      public function AssemblyRecipeModule(param1:String = "", param2:Number = 0, param3:AssemblyRecipeTypeModule = null, param4:AssemblyRecipeStatusModule = null)
      {
         super();
         this.recipeLootId = param1;
         this.targetItemId = param2;
         if(param3 == null)
         {
            this.type = new AssemblyRecipeTypeModule();
         }
         else
         {
            this.type = param3;
         }
         if(param4 == null)
         {
            this.status = new AssemblyRecipeStatusModule();
         }
         else
         {
            this.status = param4;
         }
      }
      
      public static function get instance() : AssemblyRecipeModule
      {
         return _instance || (_instance = new AssemblyRecipeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11095;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.recipeLootId = param1.readUTF();
         this.targetItemId = param1.readDouble();
         this.type = AssemblyRecipeTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
         this.status = AssemblyRecipeStatusModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.status)
         {
            this.status.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11095);
         param1.writeUTF(this.recipeLootId);
         param1.writeDouble(this.targetItemId);
         if(null != this.type)
         {
            this.type.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.status)
         {
            this.status.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

