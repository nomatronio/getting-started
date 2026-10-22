# Nomatron Getting Started Template

Nomatron is the operational control plane for Nomad. It does not replace Nomad. [nomatron.io](https://nomatron.io)

Use this repository as a GitHub template for the Nomatron educational videos.

1. Click **Use this template**.
2. Name the new repository `demo-service`.
3. Keep the default branch `main`.

The copy is the application repository Nomatron watches. This README is the on-camera path for videos 4–12.

A clone of this template is only the working directory on screen in video 4. The Nomatron server does not read these files. After video 7, work in the `demo-service` copy.

The copy contains one Nomad job, `nomad/web.nomad.hcl`. Video 11 changes `MESSAGE` in that file. The running task shows the new value.

## Session

Dev mode runs a local control plane and stores data in ephemeral Postgres for this process. Keep the same `nomatron server --dev` process, and the same ngrok session, from video 4 through video 12.

Docker is running before you start. Export `NGROK_AUTHTOKEN` from the ngrok dashboard.

ngrok requires a card before a free account can open the TCP tunnel. Complete that check under **Settings > Identity Verification**. ngrok states that the card is not charged.

`ERR_NGROK_8013` means the TCP tunnel is still blocked. Complete the ngrok verification, then start dev mode again.

`ERR_NGROK_334` means an old tunnel still holds the address. Stop that ngrok process, then start dev mode again.

Open the UI at the ngrok `https` `api_addr` followed by `/ui`. Use that same origin for every later UI action. A browser that mixes `localhost` with the ngrok origin fails the CSRF check, and the UI rejects the action.

The Nomad dev agent listens on `http://127.0.0.1:4646`. It needs no ACL token.

## Names

| Object | Value |
| --- | --- |
| Template | this repository |
| Repository after **Use this template** | `demo-service`, branch `main` |
| Nomatron organization | `acme` |
| Cluster | `dev-cluster`, connectivity `Direct`, address `http://127.0.0.1:4646` |
| App | `demo-service`, trigger **Branch-based**, ref `main` |
| Environment | `dev`, priority `1`, namespace `default`, cluster `dev-cluster` |
| Job | `web`, jobspec type `NOMAD`, namespace `default`, path `nomad/web.nomad.hcl` |
| Dev login | `root` / `nomatron123` |
| Approval policy | app-scoped, approver user `root`, required approvals `1` |

Create environment `dev` before any plan.

## 4. Start dev mode

Video: 04 — Start dev mode

From a clone of this template:

```bash
export NGROK_AUTHTOKEN="<your ngrok auth token>"
nomatron server --dev --ngrok-authtoken "$NGROK_AUTHTOKEN"
```

Leave that process running.

In a second terminal:

```bash
nomatron status
nomad agent -dev
```

`nomatron status` prints `api_addr`. With ngrok enabled, `api_addr` is an `https://` ngrok URL. Startup also logs `agent_grpc_addr` for the TCP tunnel.

Open `<api_addr>/ui`.

Stop on the **Log In** page.

## 5. Sign in and create the organization

Video: 05 — Sign in and create the first organization

1. Sign in with username `root` and password `nomatron123`. Click **Log In**.
2. If **Welcome to this Nomatron server** appears, click **Skip Guided Setup**.
3. If **No Organizations Yet** appears, click **Create Organization**. Otherwise open **Organizations** and click **New Organization**.
4. Set **Organization Name** to `acme`.
5. Set **Owner Username** to `root`.
6. Click **Create**.
7. On **Organization Created**, click **Go to Org**.

## 6. Connect the cluster

Video: 06 — Connect the first Nomad cluster

`nomad agent -dev` is still running.

1. In organization `acme`, open **Nomad Clusters**.
2. Click **New Nomad Cluster**.
3. Set **Cluster Name** to `dev-cluster`.
4. Leave **Scope** as `Global`.
5. Set **Connectivity Mode** to `Direct`.
6. Set **Address** to `http://127.0.0.1:4646`.
7. Leave **ACL Token**, **TLS Cert**, **TLS Key**, and **CA Cert** empty. Leave **Skip Verify** unchecked.
8. Click **Create**.
9. On **Nomad Cluster Created**, click **Go to Cluster**.

The cluster summary shows the address `http://127.0.0.1:4646` and **ACL Token Configured** as `No`.

## 7. Create the repository from this template

Video: 07 — Create the repository

In GitHub, on this template repository:

1. Click **Use this template**.
2. Choose the GitHub user or GitHub organization that will own the copy.
3. Name the repository `demo-service`.
4. Leave the default branch as `main`.
5. Create the repository.

Record the repository URL, for example `https://github.com/<owner>/demo-service`.

The Nomatron organization `acme` and the GitHub owner of `demo-service` are separate. Later steps use the repository URL you just recorded.

From this point, work in the `demo-service` copy. Leave the template clone as the directory where dev mode was started.

## 8. Create and connect a GitHub App

Video: 08 — Connect a GitHub App

Keep the dev-mode process from video 4 running. A restart assigns a new ngrok URL. Callback, setup, and webhook URLs must then be updated to that new `api_addr` before GitHub can reach Nomatron.

1. In organization `acme`, open **Integrations**.
2. Click **View GitHub App Integrations**.
3. Click **New GitHub App**.
4. Set **Create GitHub App For** to the owner of `demo-service`.
   - Personal GitHub account: **My Personal GitHub Account**.
   - GitHub organization: **A GitHub Organization**, then enter that GitHub organization name.
5. Leave **GitHub Provider** as `GitHub.com`.
6. Set **Connection Name** to `demo-service`.
7. Click **Open GitHub App Registration**. Allow the popup.

Nomatron fills **Webhook Secret** and opens GitHub with the registration values. On the GitHub form, confirm:

- **Homepage URL** is the ngrok `api_addr`
- **Callback URL** is `<api_addr>/api/v1/integrations/github/callback`
- **Setup URL** is the same callback URL
- **Webhook URL** is `<api_addr>/api/v1/webhooks/github`
- Webhooks stay enabled

Copy the **Webhook Secret** from Nomatron into the GitHub webhook secret field. Keep the permissions and events already on the form: Administration, Contents, Issues, Metadata, Pull requests, Webhooks, and the Push, Pull request, and Issue comment events.

Create the GitHub App. Copy **App ID**, **Client ID**, and the app slug. Generate a private key and copy the full PEM, including the begin and end lines.

Back in the Nomatron drawer, paste:

- **GitHub App ID**
- **Client ID**
- **App Slug**
- **Private Key PEM**
- **Webhook Secret** (the same value GitHub stored)

Click **Create**. On **GitHub App Integration Created**, click **Go to Integration**.

Click **Install**. In GitHub, install the app on the `demo-service` repository. Return to Nomatron. The connection status is **Installed**.

If you must restart dev mode later in this session, edit the GitHub App and replace the callback URL, setup URL, and webhook URL with the new `api_addr` paths above. Keep one ngrok session through video 12 so those URLs stay valid.

## 9. Create the app, environment, and job

Video: 09 — Create the app, environment, and job

Create the environment before any plan.

### App

1. In organization `acme`, open **Apps**.
2. Click **New App**.
3. Set **Application Name** to `demo-service`.
4. Set **Repository URL** to the `demo-service` URL from video 7.
5. Select **Branch-based**.
6. Set **Ref** to `main`.
7. Set **Nomad Cluster** to `dev-cluster`.
8. Set **GitHub App Integration** to `demo-service`.
9. Leave **Validate repository access before creating** checked.
10. Click **Create**.
11. On **Application Created**, click **Go to App**.

App settings show the trigger as **Branch commit** and the ref as `main`.

### Environment

1. Open the **Environments** tab on app `demo-service`.
2. Click **New Environment**.
3. Set **Environment Name** to `dev`.
4. Set **Namespace** to `default`.
5. Set **Cluster Override** to `dev-cluster`.
6. Click **Create**.

The first environment receives priority `1`. Confirm the card shows **Priority** `1` and **Namespace** `default`.

### Job

1. Open the **Jobs** tab.
2. Click **New Job**.
3. Set **Job Name** to `web`.
4. Set **Jobspec Type** to `NOMAD`.
5. Leave **Source Mode** as `File`.
6. Set **Default Namespace** to `default`.
7. Leave **Group Priority** empty.
8. Leave **Networking Mode** as `Job Spec`.
9. Set **Jobspec Path** to `nomad/web.nomad.hcl`.
10. Leave **Use a repository override for this job** unchecked.
11. Leave **Cluster Override** empty.
12. Click **Create**.

Job settings show jobspec type `NOMAD` and source `nomad/web.nomad.hcl`.

## 10. Add the approval policy

Video: 10 — Add an approval policy

The approval policy belongs to the app.

1. On app `demo-service`, open the **Approval Policy** tab.
2. Set **Required Approvals** to `1`.
3. Set **Approver Users** to `root`.
4. Leave **Approver Groups** empty.
5. Leave **Environment Rules** empty.
6. Click **Save Policy**.

The page shows the saved policy version. `root` can approve the plan in video 12.

## 11. Push a change and wait for the plan

Video: 11 — Push a change and review the plan

Clone the `demo-service` copy. Do this work in that copy.

```bash
git clone <demo-service repository URL>
cd demo-service
```

Open `nomad/web.nomad.hcl`. Change `MESSAGE` from `hello from web` to a new string, for example `hello from video 11`.

```bash
git add nomad/web.nomad.hcl
git commit -m "Change the web service message"
git push origin main
```

The app watches branch `main`. The push queues an approvable plan for environment `dev`.

Open app `demo-service`, job `web`. Wait until **Review Latest Approvable Plan** appears, or until the plan run shows **Approval Pending**.

Stop there. Do not approve the plan.

## 12. Approve, apply, and verify

Video: 12 — Approve, apply, and verify in Nomad

1. Open the plan run for job `web`.
2. Click **Approve Plan**.

The page reports **Plan approved. Waiting for deployment to begin...** Nomatron queues the apply from that approved plan. Stay on the plan run. The timeline moves through **Approved**, **Apply Queued**, **Apply Started**, and **Deployment Completed**.

In the Nomad terminal:

```bash
nomad job status web
nomad job inspect web
```

`nomad job status web` shows job `web` running. `nomad job inspect web` shows the `MESSAGE` value from the video 11 commit.
