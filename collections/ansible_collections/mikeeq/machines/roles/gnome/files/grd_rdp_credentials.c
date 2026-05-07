/* Compile with gcc main.c `pkg-config --libs --cflags libsecret-1` */

#include <libsecret/secret.h>
#include <stdio.h>

#define GRD_RDP_CREDENTIALS_SCHEMA grd_rdp_credentials_get_schema ()

const SecretSchema *
grd_rdp_credentials_get_schema (void)
{
  static const SecretSchema grd_rdp_credentials_schema =
    {
      .name = "org.gnome.RemoteDesktop.RdpCredentials",
      .flags = SECRET_SCHEMA_NONE,
      .attributes =
        {
          { "credentials", SECRET_SCHEMA_ATTRIBUTE_STRING },
          { "NULL", 0 },
        },
    };

  return &grd_rdp_credentials_schema;
}

void
grd_store_rdp_credentials (const char *username,
                           const char *password)
{
  GVariantBuilder builder;
  char *credentials;

  g_variant_builder_init (&builder, G_VARIANT_TYPE ("a{sv}"));
  g_variant_builder_add (&builder, "{sv}", "username", g_variant_new_string (username));
  g_variant_builder_add (&builder, "{sv}", "password", g_variant_new_string (password));
  credentials = g_variant_print (g_variant_builder_end (&builder), TRUE);

  secret_password_store_sync (GRD_RDP_CREDENTIALS_SCHEMA,
                              SECRET_COLLECTION_DEFAULT,
                              "GNOME Remote Desktop RDP credentials",
                              credentials,
                              NULL, NULL,
                              NULL);

  g_free (credentials);
}

int
main (int argc, char *argv[])
{
  if (argc != 3)
    {
      printf ("Usage: ./<programname> <username> <password>");
      return 1;
    }

  grd_store_rdp_credentials (argv[1], argv[2]);

  return 0;
}
