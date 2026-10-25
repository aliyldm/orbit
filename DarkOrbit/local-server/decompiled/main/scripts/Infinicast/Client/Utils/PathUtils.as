package Infinicast.Client.Utils
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
   import Infinicast.Client.Api.Errors.*;
   import Infinicast.Client.Api.Paths.*;
   import Infinicast.Client.Api.Paths.Handler.*;
   import Infinicast.Client.Api.Paths.Handler.Lists.*;
   import Infinicast.Client.Api.Paths.Handler.Messages.*;
   import Infinicast.Client.Api.Paths.Handler.Objects.*;
   import Infinicast.Client.Api.Paths.Handler.Reminders.*;
   import Infinicast.Client.Api.Paths.Handler.Requests.*;
   import Infinicast.Client.Api.Paths.Options.*;
   import Infinicast.Client.Api.Paths.TaskObjects.*;
   import Infinicast.Client.Api.Query.*;
   import Infinicast.Client.Impl.*;
   import Infinicast.Client.Impl.Contexts.*;
   import Infinicast.Client.Impl.Helper.*;
   import Infinicast.Client.Impl.Messaging.*;
   import Infinicast.Client.Impl.Messaging.Handlers.*;
   import Infinicast.Client.Impl.Messaging.Receiver.*;
   import Infinicast.Client.Impl.Messaging.sender.*;
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Runtime.*;
   import flash.utils.Dictionary;
   
   public class PathUtils
   {
      
      public static var infinicastInternStart:String = "/~IC/";
      
      public function PathUtils()
      {
         super();
      }
      
      public static function parsePath(param1:String, param2:String) : Dictionary
      {
         var _loc7_:String = null;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:Vector.<String> = StringUtils.splitAsPath(param1);
         var _loc5_:Vector.<String> = StringUtils.splitAsPath(param2);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(_loc4_.length > _loc6_)
            {
               _loc7_ = _loc4_[_loc6_];
               if(StringUtils.startsWith(_loc7_,"$"))
               {
                  _loc3_[_loc7_.substr(1)] = _loc5_[_loc6_];
               }
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function cleanup(param1:String) : String
      {
         while(StringUtils.contains(param1,"//"))
         {
            param1 = param1.replace("//","/");
         }
         if(!StringUtils.startsWith(param1,"/"))
         {
            param1 = "/" + param1;
         }
         if(!StringUtils.endsWith(param1,"/") && !StringUtils.endsWith(param1,"*"))
         {
            param1 += "/";
         }
         return param1;
      }
      
      public static function getObjectListPath(param1:String) : String
      {
         param1 = PathUtils.cleanup(param1);
         return PathUtils.getParentPath(param1);
      }
      
      private static function createWildcardSubElement(param1:String, param2:Vector.<String>, param3:int, param4:Vector.<String>) : void
      {
         if(param3 == param2.length)
         {
            param4.push(param1 + "/");
         }
         else
         {
            PathUtils.createWildcardSubElement(param1 + "/" + param2[param3],param2,param3 + 1,param4);
            PathUtils.createWildcardSubElement(param1 + "/*",param2,param3 + 1,param4);
         }
      }
      
      public static function getWildCardedPaths(param1:String) : Vector.<String>
      {
         var _loc2_:Vector.<String> = new Vector.<String>();
         if(StringExtensions.IsNullOrEmpty(param1))
         {
            _loc2_.push("");
            return _loc2_;
         }
         param1 = PathUtils.cleanup(param1);
         param1 = StringUtils.butLast(param1);
         var _loc3_:Vector.<String> = StringUtils.splitAsPath(param1);
         PathUtils.createWildcardSubElement("",_loc3_,1,_loc2_);
         return _loc2_;
      }
      
      public static function combine(param1:String, param2:String) : String
      {
         return PathUtils.cleanup(param1 + "/" + param2);
      }
      
      public static function combineId(param1:String, param2:String) : String
      {
         return PathUtils.combine(param1,param2);
      }
      
      public static function getParentPath(param1:String) : String
      {
         param1 = PathUtils.cleanup(param1);
         param1 = StringUtils.butLast(param1);
         if(StringUtils.contains(param1,"/"))
         {
            return param1.substr(0,param1.lastIndexOf("/") + 1);
         }
         return "";
      }
      
      public static function getLastPathPart(param1:String) : String
      {
         var _loc2_:String = PathUtils.cleanup(param1);
         if(StringUtils.endsWith(_loc2_,"/"))
         {
            _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
         }
         if(_loc2_.lastIndexOf("/") != -1)
         {
            _loc2_ = _loc2_.substr(_loc2_.lastIndexOf("/") + 1);
         }
         return _loc2_;
      }
      
      public static function getEndpointPath(param1:String) : String
      {
         return "/~endpoints/" + param1 + "/";
      }
      
      public static function endpointDisconnectedByRolePath(param1:String) : String
      {
         return PathUtils.infinicastIntern("roleDc/" + param1);
      }
      
      private static function infinicastIntern(param1:String) : String
      {
         return "/~IC/" + param1 + "/";
      }
      
      public static function escape(param1:String) : String
      {
         return param1;
      }
      
      public static function getPathAddressElement(param1:String, param2:int) : String
      {
         if(StringExtensions.IsNullOrEmpty(param1))
         {
            return "";
         }
         param1 = PathUtils.cleanup(param1);
         return StringUtils.GetStringPathEleByIdx(param1,param2);
      }
      
      public static function pathToString(param1:IPath) : String
      {
         if(param1 == null)
         {
            return "";
         }
         return param1.toString();
      }
   }
}

