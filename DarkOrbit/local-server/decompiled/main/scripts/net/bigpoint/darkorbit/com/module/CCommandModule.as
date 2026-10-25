package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCommandModule implements IModule
   {
      
      private static var _instance:CCommandModule;
      
      public var singleAttributeSelection:Boolean = false;
      
      public var args:Vector.<CCAttributeModule>;
      
      public var name:String = "";
      
      public var toolTip:String = "";
      
      public function CCommandModule(param1:String = "", param2:String = "", param3:Boolean = false, param4:Vector.<CCAttributeModule> = null)
      {
         super();
         this.singleAttributeSelection = param3;
         if(param4 == null)
         {
            this.args = new Vector.<CCAttributeModule>();
         }
         else
         {
            this.args = param4;
         }
         this.name = param1;
         this.toolTip = param2;
      }
      
      public static function get instance() : CCommandModule
      {
         return _instance || (_instance = new CCommandModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4064;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CCAttributeModule = null;
         this.singleAttributeSelection = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.args.length > 0)
         {
            this.args.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CCAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.args.push(_loc4_);
            _loc2_++;
         }
         this.name = param1.readUTF();
         this.toolTip = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CCAttributeModule = null;
         param1.writeShort(4064);
         param1.writeBoolean(this.singleAttributeSelection);
         param1.writeShort(this.args.length);
         for each(_loc2_ in this.args)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.name);
         param1.writeUTF(this.toolTip);
      }
   }
}

