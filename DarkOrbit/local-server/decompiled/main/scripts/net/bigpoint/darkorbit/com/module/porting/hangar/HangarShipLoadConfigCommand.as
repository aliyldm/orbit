package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipLoadConfigCommand implements IModule
   {
      
      private static var _instance:HangarShipLoadConfigCommand;
      
      public var title:BaseStackCommand;
      
      public var description:BaseStackCommand;
      
      public var resultId:int = 0;
      
      public function HangarShipLoadConfigCommand(param1:int = 0, param2:BaseStackCommand = null, param3:BaseStackCommand = null)
      {
         super();
         if(param2 == null)
         {
            this.title = new BaseStackCommand();
         }
         else
         {
            this.title = param2;
         }
         if(param3 == null)
         {
            this.description = new BaseStackCommand();
         }
         else
         {
            this.description = param3;
         }
         this.resultId = param1;
      }
      
      public static function get instance() : HangarShipLoadConfigCommand
      {
         return _instance || (_instance = new HangarShipLoadConfigCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14187;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.title = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.title)
         {
            this.title.read(param1);
         }
         this.description = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.description)
         {
            this.description.read(param1);
         }
         this.resultId = param1.readInt();
         this.resultId = this.resultId << 7 % 32 | this.resultId >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14187);
         if(null != this.title)
         {
            this.title.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.description)
         {
            this.description.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.resultId >>> 7 % 32 | this.resultId << 32 - 7 % 32);
      }
   }
}

