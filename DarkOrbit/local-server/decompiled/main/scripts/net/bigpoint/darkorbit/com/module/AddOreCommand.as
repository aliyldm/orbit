package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AddOreCommand extends AddMapEntityCommand
   {
      
      private static var _instance:AddOreCommand;
      
      public var oreType:OreTypeModule;
      
      public function AddOreCommand(param1:String = "", param2:int = 0, param3:int = 0, param4:OreTypeModule = null)
      {
         super(param1,param2,param3);
         if(param4 == null)
         {
            this.oreType = new OreTypeModule();
         }
         else
         {
            this.oreType = param4;
         }
      }
      
      public static function get instance() : AddOreCommand
      {
         return _instance || (_instance = new AddOreCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 147;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.oreType = OreTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.oreType)
         {
            this.oreType.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(147);
         super.write(param1);
         if(null != this.oreType)
         {
            this.oreType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

