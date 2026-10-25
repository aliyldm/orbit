package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EpicFightMessageCommand implements IModule
   {
      
      private static var _instance:EpicFightMessageCommand;
      
      public var duration:int = 0;
      
      public var type:EpicFightMessageModule;
      
      public function EpicFightMessageCommand(param1:EpicFightMessageModule = null, param2:int = 0)
      {
         super();
         this.duration = param2;
         if(param1 == null)
         {
            this.type = new EpicFightMessageModule();
         }
         else
         {
            this.type = param1;
         }
      }
      
      public static function get instance() : EpicFightMessageCommand
      {
         return _instance || (_instance = new EpicFightMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1090;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.duration = param1.readInt();
         this.duration = this.duration << 5 % 32 | this.duration >>> 32 - 5 % 32;
         this.type = EpicFightMessageModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type)
         {
            this.type.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1090);
         param1.writeInt(this.duration >>> 5 % 32 | this.duration << 32 - 5 % 32);
         if(null != this.type)
         {
            this.type.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

